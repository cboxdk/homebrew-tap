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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.26.9/telemetryd-0.26.9-aarch64-apple-darwin.tar.gz"
      sha256 "632440c8d65962df72a8aeca317025e2dc662088b7de416dcce572a74bb8faae"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.26.9/telemetryd-0.26.9-x86_64-apple-darwin.tar.gz"
      sha256 "6046990e16e31ada868d9e1132a749532310c3c0acb1d6f1fbf2995c243cfc94"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.26.9/telemetryd-0.26.9-aarch64-unknown-linux-musl.tar.gz"
      sha256 "00af1d2939d5bf8ffe19e5425c1cc917a33f3ad73ae80e84c33c1654b71c32bd"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.26.9/telemetryd-0.26.9-x86_64-unknown-linux-musl.tar.gz"
      sha256 "bb5bfdadf55f615c36fb84b501bed3836bb036d83b89a866b2fee96597fad93c"
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
