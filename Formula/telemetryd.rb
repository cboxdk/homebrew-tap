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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.13.2/telemetryd-0.13.2-aarch64-apple-darwin.tar.gz"
      sha256 "900f28a8a929c66d9ff4c510d6a084e0726976800937b6639c0fbe2234597e67"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.13.2/telemetryd-0.13.2-x86_64-apple-darwin.tar.gz"
      sha256 "0da9eaa90a55989a855963ad4ba8a3f95faa7fecdbe1347d3995ef0daa0cd354"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.13.2/telemetryd-0.13.2-aarch64-unknown-linux-musl.tar.gz"
      sha256 "f68b58a2bb155daa507f07b8a221e394bbfcccc67df1f3611d9c7ad6eeb1e77c"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.13.2/telemetryd-0.13.2-x86_64-unknown-linux-musl.tar.gz"
      sha256 "41754e62237763c776168e839f4c2043c96e09264d95044f8e32b70d48f144a3"
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
