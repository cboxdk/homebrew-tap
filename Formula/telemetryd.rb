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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.27.0/telemetryd-0.27.0-aarch64-apple-darwin.tar.gz"
      sha256 "e10e1942224ac19ea85f4513282c271d9d1f9f3bbff768dfbcf56ff4a7f57747"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.27.0/telemetryd-0.27.0-x86_64-apple-darwin.tar.gz"
      sha256 "418872e6e17e433b69928dd706e1344f0279a86135c59e97ddcd9c198e6bf09c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.27.0/telemetryd-0.27.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "bca19f8a4ecd03e65412e7ff80129f91568bc63ad099570fb9b3cd7c7f3891e4"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.27.0/telemetryd-0.27.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "3ae6123d7319d0a498602282aa4dcdef3b1bd113c024c01a98c4d35b83bbdcdc"
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
