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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.26.2/telemetryd-0.26.2-aarch64-apple-darwin.tar.gz"
      sha256 "891d0dc4caec204a61fef9ed3ebaeceb063f0c93bfb1d2c5b565d45290538ed8"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.26.2/telemetryd-0.26.2-x86_64-apple-darwin.tar.gz"
      sha256 "763e1364767fd8da312fc9d1b37c52fa18a448edfcc02dffca3ad3d7de65bc93"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.26.2/telemetryd-0.26.2-aarch64-unknown-linux-musl.tar.gz"
      sha256 "5b29ab14aa01917606d0983e80da92aed62051ec29482b3ee1979d76e83eeeef"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.26.2/telemetryd-0.26.2-x86_64-unknown-linux-musl.tar.gz"
      sha256 "16e8be31223099401055adf40ea978ca0860a35f09259f8938bc21e0c4a023ea"
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
