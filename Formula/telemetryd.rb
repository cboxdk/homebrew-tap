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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.22.1/telemetryd-0.22.1-aarch64-apple-darwin.tar.gz"
      sha256 "5382cdddf94225e81a7b0468b8d89a544c6cd5fc4d9677a7e85765747a221697"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.22.1/telemetryd-0.22.1-x86_64-apple-darwin.tar.gz"
      sha256 "695f38f43481ad26c35469c826c957fb57646c03669314977c4e87f62a24cc78"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.22.1/telemetryd-0.22.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "3e10fe00613486183c99d77343c653098014084f3b2fcb461318da8c0b979339"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.22.1/telemetryd-0.22.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "fc24363926bdc75be8adbfd6d699239b89e9e87aaa4507dba1aa2e0acce2f1b4"
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
