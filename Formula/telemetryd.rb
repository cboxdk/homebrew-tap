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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.69.2/telemetryd-0.69.2-aarch64-apple-darwin.tar.gz"
      sha256 "1e9e3860763628bf7ebbe366d6006890c7e601ae349fa1d64892565b9a71e5c1"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.69.2/telemetryd-0.69.2-x86_64-apple-darwin.tar.gz"
      sha256 "c5f93db92eddd3896ae4147a346c76c3097c435c01e34b44d531b63d064ebf5d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.69.2/telemetryd-0.69.2-aarch64-unknown-linux-musl.tar.gz"
      sha256 "ca14c069aed8036b606e46388d9415a97c89b0d9d8ba87b612b64deb5634b669"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.69.2/telemetryd-0.69.2-x86_64-unknown-linux-musl.tar.gz"
      sha256 "6867c40056f71710b3845388fc6ed9481cb1228171ae706966175e6f14e0276a"
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
