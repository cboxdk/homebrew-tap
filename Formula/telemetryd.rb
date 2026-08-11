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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.26.1/telemetryd-0.26.1-aarch64-apple-darwin.tar.gz"
      sha256 "69026fadbe024b1533ee78ee41918c95dac86e8064dac6aed41fdba7a7b6b85d"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.26.1/telemetryd-0.26.1-x86_64-apple-darwin.tar.gz"
      sha256 "fdf8bd8d60e099b2f3e0b42616b31cf18c70cf529f94ef48dab9d1b6339b6b7c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.26.1/telemetryd-0.26.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "a6cc7ba235dfce7f1d469310784da447726afd64baa718a202b56e6d9f9d8b27"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.26.1/telemetryd-0.26.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "34af8b6a0794e0a2a3efacaa8b9b835976e6e0f1c160b884483f27c34179acac"
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
