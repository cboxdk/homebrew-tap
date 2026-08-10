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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.24.2/telemetryd-0.24.2-aarch64-apple-darwin.tar.gz"
      sha256 "fca47d34889b9742c0607391bbbd260836ac505bcd512a746e11582ae7c6e877"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.24.2/telemetryd-0.24.2-x86_64-apple-darwin.tar.gz"
      sha256 "3f01e409ac30200ec356ee9b6c6ec11e9c6e5a30e0f8d23ad55e75b68c715f28"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.24.2/telemetryd-0.24.2-aarch64-unknown-linux-musl.tar.gz"
      sha256 "cb29637a7941d7a7a0cf9244e769ff0222d2abdef5af8bfbb1510246789c6813"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.24.2/telemetryd-0.24.2-x86_64-unknown-linux-musl.tar.gz"
      sha256 "7f4b529aa6074e8d93d81127798afb0a2d1e40e850d54a87efdfa9d440e699af"
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
