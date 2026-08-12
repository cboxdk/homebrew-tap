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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.32.0/telemetryd-0.32.0-aarch64-apple-darwin.tar.gz"
      sha256 "65fc047d39c0ef1007b086816a7a3efe1ea6651cd745f1ad5d3fafbd54689fa1"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.32.0/telemetryd-0.32.0-x86_64-apple-darwin.tar.gz"
      sha256 "e121c7898917da2acf8b08a74ef23fdcb3a21e9837bf7d5646485d355ddb63ca"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.32.0/telemetryd-0.32.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "e322c7c19db4a637fd47050f6835ffdb5977b0b2121c078440abe8194b349a39"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.32.0/telemetryd-0.32.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "72653685f2c89187be4f3f0d6ecdb19ce5bdbc2801c98d17feb675f8fecf7354"
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
