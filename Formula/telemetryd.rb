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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.25.1/telemetryd-0.25.1-aarch64-apple-darwin.tar.gz"
      sha256 "487cef77df7cf41f5ab625a240d4a05291961463041fbf8666257c9f58aaf720"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.25.1/telemetryd-0.25.1-x86_64-apple-darwin.tar.gz"
      sha256 "523e970f81fecf7a7bd98ae8f11408061effa970f92fa813da579dde66a796d4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.25.1/telemetryd-0.25.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "ff4622ba2c0ae7fe2852510eca22de75269dc3fe46a358aa49113eb1373b7c0e"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.25.1/telemetryd-0.25.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "534a08c8821a4c5b5597601382e836e22d4088eb396a5e746a2b9294bfed99eb"
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
