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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.24.1/telemetryd-0.24.1-aarch64-apple-darwin.tar.gz"
      sha256 "15387013a5a03a44ba6201b2a0814e069e109094081778077957618b79649c94"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.24.1/telemetryd-0.24.1-x86_64-apple-darwin.tar.gz"
      sha256 "21493a0897d96434fb953665610369ca570acbd9e0eb7d5ee24c1de0a79c7838"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.24.1/telemetryd-0.24.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "bb87ea3793691d0afa261cc50e92228b333f52b50407b2b115e29254da1ddc9f"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.24.1/telemetryd-0.24.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "8a4da2cb20b1b0b6d37720b0540a46c6c5427b4fed7d8b1df72874994ec64ff5"
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
