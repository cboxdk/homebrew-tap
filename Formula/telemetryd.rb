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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.26.5/telemetryd-0.26.5-aarch64-apple-darwin.tar.gz"
      sha256 "343e60b31edb6f848a33459947d07055d646292380839873e70e75c89221f929"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.26.5/telemetryd-0.26.5-x86_64-apple-darwin.tar.gz"
      sha256 "5374f19872d84726ecfd6825ef49e93b9f03ea5841619f25218f955a74809994"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.26.5/telemetryd-0.26.5-aarch64-unknown-linux-musl.tar.gz"
      sha256 "d9c826622fbf1a39766c1fcb39100db12355a6c17f1488a9cbed3fadb063c392"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.26.5/telemetryd-0.26.5-x86_64-unknown-linux-musl.tar.gz"
      sha256 "2cfe79ccd607112847f0cae8a68360172fb16982a0f4880dd46f9a24530343d8"
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
