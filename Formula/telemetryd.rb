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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.21.0/telemetryd-0.21.0-aarch64-apple-darwin.tar.gz"
      sha256 "e0a36fa2f1f75dc580a066541f5ec444750b6cb6015800c47c86ddfda306e3f7"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.21.0/telemetryd-0.21.0-x86_64-apple-darwin.tar.gz"
      sha256 "f527d6224df68a3659f00bf8ecfa9b55a41bd29c7cb83bd6594d33cd12421477"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.21.0/telemetryd-0.21.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "58796e9f1de60def563ee690155fe7d47aaac63da50ad5ac572638a0ba778fbf"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.21.0/telemetryd-0.21.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "c2131d2a387c30ee28ee3bcba69293cce414c1804e7ff7d01b9813a5c63a6a2c"
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
