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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.15.1/telemetryd-0.15.1-aarch64-apple-darwin.tar.gz"
      sha256 "41c5c83cd276b4ba5b1f34626f852f418ab6e8a175840de84ccd77530a02040e"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.15.1/telemetryd-0.15.1-x86_64-apple-darwin.tar.gz"
      sha256 "79d28681a07c6d9d5f8e77b1be490c13ca4e7d6de8bec5b744808a6af33de18a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.15.1/telemetryd-0.15.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "18e0f52672ee3456c63689b16590e9f1430df4f9d4cf549a49b7b71538fe047b"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.15.1/telemetryd-0.15.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f611d5014dd150431fbcf90b7b371937aad591c45b98d3c9056ed844ea965b06"
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
