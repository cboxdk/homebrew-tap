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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.65.0/telemetryd-0.65.0-aarch64-apple-darwin.tar.gz"
      sha256 "137885ca937b9d53df0ba9e05e76a386d4b38513d9e3920dbbc0f491caead709"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.65.0/telemetryd-0.65.0-x86_64-apple-darwin.tar.gz"
      sha256 "8ebc729fc1e7600e908fc286d568561ac20b55307e7c7e8d174756ca504ce165"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.65.0/telemetryd-0.65.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "c95a0f2d961727b190f4223c9d448eed2273ca5c5f32b316f6e84bdad1ded013"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.65.0/telemetryd-0.65.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "fdae1d4adafee498399d765dc2ef1af900aee1bf5288951b3959ece1a37e80ec"
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
