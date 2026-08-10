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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.25.2/telemetryd-0.25.2-aarch64-apple-darwin.tar.gz"
      sha256 "cb9680b1aa0c9ad22f349b60eb404b56786976011569175284744df6fae7f337"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.25.2/telemetryd-0.25.2-x86_64-apple-darwin.tar.gz"
      sha256 "d520baa15ded77580fc1188508de44dfaa792bdc9bbecf6fbc4f7b81106fffcf"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.25.2/telemetryd-0.25.2-aarch64-unknown-linux-musl.tar.gz"
      sha256 "584e1e2f4334170c486c0e1ad680f0f569047b82ef0d72031909f14cccb3ae81"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.25.2/telemetryd-0.25.2-x86_64-unknown-linux-musl.tar.gz"
      sha256 "6f6fb0e6d6337b3c5afc189815acce745709b8ae59fa6d029ae39cfc3d490ce5"
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
