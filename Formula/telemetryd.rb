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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.16.1/telemetryd-0.16.1-aarch64-apple-darwin.tar.gz"
      sha256 "c9c4e21988c872356b852c236919db7d1ce19de19137184d1a765a53e9bec472"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.16.1/telemetryd-0.16.1-x86_64-apple-darwin.tar.gz"
      sha256 "357e8a972da03646bca9b64a9f6f7f847218d44bf9a57dd51d18f313460d45f5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.16.1/telemetryd-0.16.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "9e6e10b1e623f61998618b2fc3e25ba07ba4d3386fdd107f20af6fee68411026"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.16.1/telemetryd-0.16.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "eabfaf4e3910fb3aecaa5272eaa6a54f53d252248407d784b8c1cfe95c535e37"
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
