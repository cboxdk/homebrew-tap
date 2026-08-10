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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.23.0/telemetryd-0.23.0-aarch64-apple-darwin.tar.gz"
      sha256 "229a02f81b368d78c1ca99df44d88023c85d5135e2c1d155c4d7b1d1eb11cad2"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.23.0/telemetryd-0.23.0-x86_64-apple-darwin.tar.gz"
      sha256 "dac046ea8973abefd1b7be0927f1c6598c609abd9b5a6909ee0580df218d6fed"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.23.0/telemetryd-0.23.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "3a9e5403706033c48e441cc7d8c9fb72b518f431c957012fdff32d265d0dabca"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.23.0/telemetryd-0.23.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "8885b6b0c7985c32a5e930c89fa5f4c89abb7794449cdd872de3e66792d72dd6"
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
