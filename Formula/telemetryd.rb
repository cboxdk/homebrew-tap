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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.19.0/telemetryd-0.19.0-aarch64-apple-darwin.tar.gz"
      sha256 "68b827a5d07385bcfc6e9e1da43122d2764b438b52b96baac37d412c7a6d8599"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.19.0/telemetryd-0.19.0-x86_64-apple-darwin.tar.gz"
      sha256 "f65dcac9ab2611ebca0079fbcbd02e32dccfd657f7e1a0562a67f2c3f2741fa9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.19.0/telemetryd-0.19.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "d4b65df69b874ad1bcb407b2b6d8f0b5895837bac959f32770cc743853a8ba6d"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.19.0/telemetryd-0.19.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "48891b8a4d7045887c3c6633cee3c0d215fe6274fba8003c24a666b9057261e6"
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
