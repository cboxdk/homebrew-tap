# Homebrew formula for telemetryd.
#
# Lives here so it is versioned with the code it installs, which is what stops the
# formula describing a version that was never built.
#
# `scripts/publish-formula.py` fills in the checksums from a published release and
# pushes the result to cboxdk/homebrew-tap. The placeholders below are deliberate: a
# formula with real-looking checksums that nobody verified is worse than one that
# obviously is not ready.
class Telemetryd < Formula
  desc "Single-binary observability backend: OTLP in, Loki/Tempo/Prometheus APIs out"
  homepage "https://github.com/cboxdk/telemetryd"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.38.0/telemetryd-0.38.0-aarch64-apple-darwin.tar.gz"
      sha256 "6b257344ae997123f6604f369081995ed0046aa2aff3d30d3d447fc57aae8cd6"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.38.0/telemetryd-0.38.0-x86_64-apple-darwin.tar.gz"
      sha256 "ae090b767f96b439112fb2b4df63ace1b4199205993c9d6869bf132e0b87fbce"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.38.0/telemetryd-0.38.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "4fbe2f4d7e77d3cf22b67ea16642b321b2029f2b42efd4fa79f1656d6381cbcb"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.38.0/telemetryd-0.38.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "ec3f5d304cc8bd02c0645eba2ccbfdf5a956301f564c2b8702b8765f069cfb1a"
    end
  end

  def install
    bin.install "telemetryd"
    doc.install "README.md", "COMPATIBILITY.md", "SECURITY.md"
    (etc/"telemetryd").install "telemetryd.toml.example"
  end

  service do
    run [opt_bin/"telemetryd", "serve"]
    keep_alive true
    working_dir var
    log_path var/"log/telemetryd.log"
    error_log_path var/"log/telemetryd.log"
  end

  test do
    # `version` proves the binary runs and reports its build target; `validate` proves
    # it can resolve a complete configuration from nothing, which is the product's
    # central claim.
    assert_match version.to_s, shell_output("#{bin}/telemetryd version")
    assert_match "Configuration is valid",
      shell_output("#{bin}/telemetryd validate --data-dir #{testpath}/data")
  end
end
