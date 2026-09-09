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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.51.0/telemetryd-0.51.0-aarch64-apple-darwin.tar.gz"
      sha256 "d0c2e134447e03baa83fa88c188e70a36a55ba3d362e12a4475abb142d481b84"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.51.0/telemetryd-0.51.0-x86_64-apple-darwin.tar.gz"
      sha256 "4a9c46730691d661c03046e0172ebf371aae17132dfece569df314d310a7be1e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.51.0/telemetryd-0.51.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "87901a0da38c01e90656f042f6e5785d45d32defc8e7b7aec86db991cd3ba560"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.51.0/telemetryd-0.51.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "35a99c8c6777d4df6d934af68f8e518c02f65d1c088ea568352bb63be1d28410"
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
