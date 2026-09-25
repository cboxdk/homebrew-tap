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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.62.0/telemetryd-0.62.0-aarch64-apple-darwin.tar.gz"
      sha256 "f2a98d1abaaf2539c8f2ba8d6c1d3d44819e52bf8b6f449a8255438ce7da2b72"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.62.0/telemetryd-0.62.0-x86_64-apple-darwin.tar.gz"
      sha256 "86ea291a6ec26ed63ac845325c21f93687bd2dbd71d8c65b84ea7625a7e6f08e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.62.0/telemetryd-0.62.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "a973da6f9d3c62c2aaf2c54c4f06ee9c29f287156fc67de1b161c1c71472b4f7"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.62.0/telemetryd-0.62.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "4f2e70c95d6d559e0e75a7f905340de2a52b8b3c2bdc438078cbb664ba7338ad"
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
