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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.72.0/telemetryd-0.72.0-aarch64-apple-darwin.tar.gz"
      sha256 "205311975c0721e1cf29fdbed0aa367a569837805bd804099fd9e8b6ec945270"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.72.0/telemetryd-0.72.0-x86_64-apple-darwin.tar.gz"
      sha256 "3197ef759183ac82c105e506307b4fea7ef41042391f2caca993348a9abd38bc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.72.0/telemetryd-0.72.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "ddd07ca8b0f2223fdea58902afd359776c461cad9c6815105006bda9c4c619a5"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.72.0/telemetryd-0.72.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "7c8fbddb5e9cd8d4dd1170d6bad39f99570824b9ff46e0e8ed9aad4d45eeaf56"
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
