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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.46.3/telemetryd-0.46.3-aarch64-apple-darwin.tar.gz"
      sha256 "e7c9f472b888b68de4ac5842df2288eab7bbebc6fa836965ade5f5fd5f305e79"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.46.3/telemetryd-0.46.3-x86_64-apple-darwin.tar.gz"
      sha256 "bbdb0dc15df4531d928df62dcea35c64c85a29428de3b9674fa50adf0dee1729"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.46.3/telemetryd-0.46.3-aarch64-unknown-linux-musl.tar.gz"
      sha256 "334930a32b38950a0e5e4938b28055ee882032dee2b5f9cf660d99af3f93d5a8"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.46.3/telemetryd-0.46.3-x86_64-unknown-linux-musl.tar.gz"
      sha256 "48b29310ae7b616825887e3f5c1b1741f7f14efaebae2f46bd44af9ccf435489"
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
