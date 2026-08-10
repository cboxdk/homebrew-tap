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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.20.7/telemetryd-0.20.7-aarch64-apple-darwin.tar.gz"
      sha256 "4372f96ba82e7316d45b4d7dc7d638c428042d7d53f8aa4c3e97c65ffb3dbe3b"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.20.7/telemetryd-0.20.7-x86_64-apple-darwin.tar.gz"
      sha256 "e2238c36160e0bef726b1865610fe1d1403c1c595856e2dc854e58374c5ae5ff"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.20.7/telemetryd-0.20.7-aarch64-unknown-linux-musl.tar.gz"
      sha256 "2bae97bdaa81fd1648fdc02d6b94c5091a852b52828cad8b6bc56782d457db76"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.20.7/telemetryd-0.20.7-x86_64-unknown-linux-musl.tar.gz"
      sha256 "65b87265c74fa2f62f8ab32296df74ae4a3080cf7b63a785f22749abfb77f63a"
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
