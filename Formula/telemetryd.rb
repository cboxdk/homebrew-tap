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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.24.3/telemetryd-0.24.3-aarch64-apple-darwin.tar.gz"
      sha256 "5ae17b09b235c99ee2b086e8788f15d7609f06f114b6b2f3567d6bb4334b489a"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.24.3/telemetryd-0.24.3-x86_64-apple-darwin.tar.gz"
      sha256 "2f32768b4e9905139dbefb9877bed3c99b27e772a878639fced61a25a4dd3ded"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.24.3/telemetryd-0.24.3-aarch64-unknown-linux-musl.tar.gz"
      sha256 "ffff82372cbef9efdf7b9c3e836ec3b9b1a561b71b73dfc0c8f3a93ee970f433"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.24.3/telemetryd-0.24.3-x86_64-unknown-linux-musl.tar.gz"
      sha256 "35072f45f30718791f898327aea5db58c0d36cf1d17cf24efd6c0381756ff992"
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
