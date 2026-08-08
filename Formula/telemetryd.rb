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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.12.1/telemetryd-0.12.1-aarch64-apple-darwin.tar.gz"
      sha256 "2ed3dd76f64523b17a9c3256a08e26e8f7addaab60b43b3508d1208879b3bd9f"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.12.1/telemetryd-0.12.1-x86_64-apple-darwin.tar.gz"
      sha256 "7436d2b939f320c303a72a5d444aef70fa7fd7908edfed10ff4f711be67589e0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.12.1/telemetryd-0.12.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "41a407f4ee32380ecce68de2c8689a46264bfac031f9a67e4ed329aacb26d316"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.12.1/telemetryd-0.12.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "7e17971c8998e4eda2d456a549e1a5e47fac401328b52df90ff25737f53a831b"
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
