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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.20.3/telemetryd-0.20.3-aarch64-apple-darwin.tar.gz"
      sha256 "97dae1d5dcebae282ae93d629b9fa8a386f5e726f898b63de4fe09415e622351"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.20.3/telemetryd-0.20.3-x86_64-apple-darwin.tar.gz"
      sha256 "b391ea6f8c0995367ad01b200baa79242d7716f6077ae54468e77765fba5f20e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.20.3/telemetryd-0.20.3-aarch64-unknown-linux-musl.tar.gz"
      sha256 "046e235178b389e0499bf6b4c0216b0b7d9816a8f624c5befe9745b132960bfc"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.20.3/telemetryd-0.20.3-x86_64-unknown-linux-musl.tar.gz"
      sha256 "4434bddc64f96b09db73db0791df5525e71d0fbdfd599ac3b62aa91fc0e9895d"
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
