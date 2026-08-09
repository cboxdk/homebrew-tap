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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.17.0/telemetryd-0.17.0-aarch64-apple-darwin.tar.gz"
      sha256 "9dcb570c6f95613d2efa52e9e7efa7e673f5572c3a5dad2eb8c81e73fbf1113c"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.17.0/telemetryd-0.17.0-x86_64-apple-darwin.tar.gz"
      sha256 "5714dca19b7bb39c0d7c890ac2c7cdaf58312bc033f52079f260d6e2613fc15b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.17.0/telemetryd-0.17.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "47e3d8192c4fa99c4518d1b2303aabd92c0f5694241c3d013825a58024dc85e9"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.17.0/telemetryd-0.17.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "5f8e8e16bf1064ad8d8424b50dc6b5e6cfe689640c673730a12f707f606b58fa"
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
