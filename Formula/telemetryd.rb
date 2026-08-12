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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.30.0/telemetryd-0.30.0-aarch64-apple-darwin.tar.gz"
      sha256 "b6144c8aa465d8f46d1b100eabaf3455781abc7523745763b4c34bc157a16a7f"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.30.0/telemetryd-0.30.0-x86_64-apple-darwin.tar.gz"
      sha256 "648d5f5e6a3e2a0b11654e7766ec83927a83ed07c85b36e182c4859b94dd151e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.30.0/telemetryd-0.30.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "dae0128d70164a574f3b8d5af33b1c3450df0f2b84371802d2dc61f2e4bf60fd"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.30.0/telemetryd-0.30.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "96d172b932cdf9ca26b1cd3a4e3d71c5dc9b5b18e901606b98261b5e4bec5f17"
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
