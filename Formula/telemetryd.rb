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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.55.1/telemetryd-0.55.1-aarch64-apple-darwin.tar.gz"
      sha256 "88590b0ac43c0a3f68a66b51be42566f2403b14200e48b396d175a7150bd2683"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.55.1/telemetryd-0.55.1-x86_64-apple-darwin.tar.gz"
      sha256 "46c63babf23264e3daaa5d7cee2f4b0e46dd218c37a0fa020f4f7ff4d4968d77"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.55.1/telemetryd-0.55.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "7f200c2fc50b228928c628da2c344b603843421d75c09d64e2a32aa3b18b7a48"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.55.1/telemetryd-0.55.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "75e1b4645ecd2ef5a30f8b72cd8b639795603187fde358c476bc00abc5611601"
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
