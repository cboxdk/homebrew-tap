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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.49.0/telemetryd-0.49.0-aarch64-apple-darwin.tar.gz"
      sha256 "84b5fd19d71b9cb9db46a434135d869cc7ca61bdb2c71e1667ca20b4f9759706"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.49.0/telemetryd-0.49.0-x86_64-apple-darwin.tar.gz"
      sha256 "5e85154b01f5b80338a3a91790079dbe56ad497ef8a73e23dbefb9b15db685f4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.49.0/telemetryd-0.49.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "16fba5013f622ddf51711083bb8c043e7694c533bbfb34f24b07ca04b2b24ff7"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.49.0/telemetryd-0.49.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "99f0fe111b211caf5d53367c9289b8d2ef3c8c4cadfb98b764a0cab085aed1ac"
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
