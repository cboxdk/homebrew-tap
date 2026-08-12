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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.36.0/telemetryd-0.36.0-aarch64-apple-darwin.tar.gz"
      sha256 "343b11542bc2e37e5ff5b0cf6dbd311804f3f959b91a9edf0fceeab510e07837"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.36.0/telemetryd-0.36.0-x86_64-apple-darwin.tar.gz"
      sha256 "2fa82f30196b1a2b70ed3b604dee57648105c9a7b65e0dee9b0bf73b66aefe55"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.36.0/telemetryd-0.36.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "1a3086c7433dc56e0e74b627658f2bf0251c548bcb989debf3e6e596701cd170"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.36.0/telemetryd-0.36.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f5e4d7e539a69204252e483b49f630133d7e217ef0a29616007ffe7c9478139e"
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
