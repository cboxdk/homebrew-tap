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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.20.0/telemetryd-0.20.0-aarch64-apple-darwin.tar.gz"
      sha256 "b75a1d552c448ef13b326a47e0a6928578d19189d391b90076ad5182f617c46a"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.20.0/telemetryd-0.20.0-x86_64-apple-darwin.tar.gz"
      sha256 "104ed6d0b8069b171adc320c9d46a71c73ed3e0cbb4308bac178fd1699c4e8d0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.20.0/telemetryd-0.20.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "f353e060f71ebcd5f411f16026f8bcda9c75bb5b51ea5d810884b501b76a88ff"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.20.0/telemetryd-0.20.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "8aa740a70eea4dceb854876e0e464e5b6d47d8ebd2efe65fc77ce70de575dcf0"
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
