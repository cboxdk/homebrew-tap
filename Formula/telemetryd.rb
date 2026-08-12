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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.35.0/telemetryd-0.35.0-aarch64-apple-darwin.tar.gz"
      sha256 "5cae926230f9f0b20223cd54a1c08aec2d8cfb1e6b126632217b236870713c3f"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.35.0/telemetryd-0.35.0-x86_64-apple-darwin.tar.gz"
      sha256 "83216142d7ae83ecd37c1e25c7a21b7829b349a7ab30c10b6d0397319a0b4b90"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.35.0/telemetryd-0.35.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "64c2a90fa1d9e3c6dcd1f4c06ce9538345c54036428e1a91d7073a3d63fb0e4a"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.35.0/telemetryd-0.35.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f04e93e53887cb808a32df7801a3fd40d9c1be8b35c172a299275562fa886ea2"
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
