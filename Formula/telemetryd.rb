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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.54.0/telemetryd-0.54.0-aarch64-apple-darwin.tar.gz"
      sha256 "883bd7cdd4c4dc8cec4bfd07ce72d975a57c6fd181d66bff31d17de9e9229a79"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.54.0/telemetryd-0.54.0-x86_64-apple-darwin.tar.gz"
      sha256 "52bc76849c121421b3fcd18d57fe669a7d693a772f92c09181349af36525db61"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.54.0/telemetryd-0.54.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "7e153126f2900e74907f529fc1330d71e7a08bfbd3d2f7c6c520b15dcfab1b70"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.54.0/telemetryd-0.54.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "40a381e7149b6e298095a81b49e1e45c30159fff5b362deb26ce375755072a9f"
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
