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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.26.6/telemetryd-0.26.6-aarch64-apple-darwin.tar.gz"
      sha256 "ddf6d22254ba76302f9fae29c2cdc48bc2f2258fd6504b6a5ac4bce4c366feb1"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.26.6/telemetryd-0.26.6-x86_64-apple-darwin.tar.gz"
      sha256 "19692b3bbb6bab56c61d0c17e02205583a79f405969e41804ae8f25768b27905"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.26.6/telemetryd-0.26.6-aarch64-unknown-linux-musl.tar.gz"
      sha256 "13e7f36aa5da36a7bada1c43a753bd71c0d4b934a06842646086979a1cf919b1"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.26.6/telemetryd-0.26.6-x86_64-unknown-linux-musl.tar.gz"
      sha256 "22e28a54f0ca0793826993a7ec77c5f01b34f1e7506078ffa1246d53057d476c"
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
