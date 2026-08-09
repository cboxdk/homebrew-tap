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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.20.1/telemetryd-0.20.1-aarch64-apple-darwin.tar.gz"
      sha256 "807e3c1415e0307abf48221c8d36f9429a9fefa0dd11096f365d8738f4c123db"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.20.1/telemetryd-0.20.1-x86_64-apple-darwin.tar.gz"
      sha256 "4322b2999e2bf78d4b193cd6f4686bfb296057e95e610d89a04e97cf9a8b83bf"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.20.1/telemetryd-0.20.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "f956877af8c2928ca0aa248d87b46b229f0ace511a1565c523ce97f8b80b182d"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.20.1/telemetryd-0.20.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "172f99ca26d3e911a2691452d78f757a670209c7d0998d85ddd943dc39f3a2d6"
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
