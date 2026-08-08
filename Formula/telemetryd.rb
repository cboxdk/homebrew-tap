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
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.13.0/telemetryd-0.13.0-aarch64-apple-darwin.tar.gz"
      sha256 "0edfcff38022e40785a26f5b06e3a38bccf4571d6ce4013f654de96ae5051a3a"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.13.0/telemetryd-0.13.0-x86_64-apple-darwin.tar.gz"
      sha256 "244d1e6d547e9a81caa376ac1c5dbfa62648d2c81c692d99f23ebee8855914ac"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.13.0/telemetryd-0.13.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "739c5efcc5b75403ca758ed63deb810348fbfeb6f475ae96f3a02c24e90ea7c1"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.13.0/telemetryd-0.13.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "2e0c39f2e03f3e27296322cabf32e77e2a499f96fb6c29f3f15e1638a566113e"
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

# write-path probe: removed automatically when the publisher rewrites this file
