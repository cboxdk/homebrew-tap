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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.20.6/telemetryd-0.20.6-aarch64-apple-darwin.tar.gz"
      sha256 "84af2f144537c5d2fbfdc589345aed106e5eba9d81164736ea9c2ff8a74bcc66"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.20.6/telemetryd-0.20.6-x86_64-apple-darwin.tar.gz"
      sha256 "37d44367e64dbf01bfb7ce031b96297648751d2d6aeca0ceef8b87c3e2a41712"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.20.6/telemetryd-0.20.6-aarch64-unknown-linux-musl.tar.gz"
      sha256 "00ef50a1292574fc12a2e7ca69c1b830a482f0284821a4e3b4dcd2cbe93ce139"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.20.6/telemetryd-0.20.6-x86_64-unknown-linux-musl.tar.gz"
      sha256 "a537b5c629724abf523bec92830d7fef703649ba0bc271a065ed3cf23e1958b9"
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
