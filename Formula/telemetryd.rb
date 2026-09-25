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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.59.0/telemetryd-0.59.0-aarch64-apple-darwin.tar.gz"
      sha256 "32e41b399a74d4cbc2aaee752073f1c511b21949cb1d1e0b92fcefc765af8cf8"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.59.0/telemetryd-0.59.0-x86_64-apple-darwin.tar.gz"
      sha256 "35e2fe94f28977170ba0f67909fa35387293e5165f6be0818c39063c98b39e8e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.59.0/telemetryd-0.59.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "e493b3131d83bb6389a8f0ee98654ee8a8bf00013f8f0a31a71bc99f670451db"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.59.0/telemetryd-0.59.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "e651d2dec64cb5051b27e87223cecb94278fb68cecc4778d6cccb340cdbfc239"
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
