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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.68.0/telemetryd-0.68.0-aarch64-apple-darwin.tar.gz"
      sha256 "524c6ddb9b053c2cb08cd288f9d02bd416603e3074312c294da55e99705457c2"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.68.0/telemetryd-0.68.0-x86_64-apple-darwin.tar.gz"
      sha256 "fa1b788c82b59738947d54fa2e75468db7f8b1f9b9521361d3e78f772273dc41"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.68.0/telemetryd-0.68.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "57cebf28afb9bc669435bbf83e2d4088a6a54eee2043fbe8ccaaffbcdd93551c"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.68.0/telemetryd-0.68.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "efdefdfe37f5e31f67584fa4c6843767c3e5f7d8b1e97f9eaef72b6eefcb64a0"
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
