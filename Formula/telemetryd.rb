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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.64.0/telemetryd-0.64.0-aarch64-apple-darwin.tar.gz"
      sha256 "b5ea94a7308534752fd7c133b9a3d4f601a52231dcd051b9f0e0b7e593ebd638"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.64.0/telemetryd-0.64.0-x86_64-apple-darwin.tar.gz"
      sha256 "0f54f1cfaa1842810f07be01cd8f043a4cb1804e104f18dbf4884476b07d00cf"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.64.0/telemetryd-0.64.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "9ee39db2fd6fa00a91a27ca3724354939d927d047b35adc84cf3fb8355cf8b4f"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.64.0/telemetryd-0.64.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "a483e34d860071554f2a5bce77f127d54dd742a22553e9a660c225e50ef4fb23"
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
