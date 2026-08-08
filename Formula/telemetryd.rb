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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.14.1/telemetryd-0.14.1-aarch64-apple-darwin.tar.gz"
      sha256 "81ab723baacdfd8dcde7d1feeb127cc21882bf4d469a642bc54c6646dab95942"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.14.1/telemetryd-0.14.1-x86_64-apple-darwin.tar.gz"
      sha256 "d03352b32ca00fe6a28bffb65db4df58dc84084037233480374fbfa7431ababb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.14.1/telemetryd-0.14.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "2aad82daf829acb49e579e0118868fd8c50e8a38473b8ce4cc03e8e669f4ed38"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.14.1/telemetryd-0.14.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "8774be375ac8b1cd7d2fe6cae1da7ca18056dfaa6a4d69cd4f06137dcdd3d7aa"
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
