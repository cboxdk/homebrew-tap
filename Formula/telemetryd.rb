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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.61.1/telemetryd-0.61.1-aarch64-apple-darwin.tar.gz"
      sha256 "98591b2a18da7f2ca2a033e650c3366a84d83880cc572b7f2d7b910497418d31"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.61.1/telemetryd-0.61.1-x86_64-apple-darwin.tar.gz"
      sha256 "8112501378b57647674b95f8e99f21b7027f3cd5b993b741bfa351fb1f987c1f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.61.1/telemetryd-0.61.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "e83dab2deac9b4098d972749e39e5b8e7235467ca928784acc3606adc30116fb"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.61.1/telemetryd-0.61.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "42e781add4dc8764a98137028e1ba0b82efff81778bf8ba1b509f8018558f5ea"
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
