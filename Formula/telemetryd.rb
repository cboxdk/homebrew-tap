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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.16.0/telemetryd-0.16.0-aarch64-apple-darwin.tar.gz"
      sha256 "ae3247eda3d69680bc3ea1a315ef5f9d521610a080415059e3f7c35feb5206eb"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.16.0/telemetryd-0.16.0-x86_64-apple-darwin.tar.gz"
      sha256 "ba217891fd7f8702d4f63e0f010b85f522c4634f1cd2293403a43d4df23462f8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.16.0/telemetryd-0.16.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "efbd92c52918ee05a3ecbeb95f92f34dd42c13983ce9e4555ca1c0b5e9c944ff"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.16.0/telemetryd-0.16.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "fafb3597bc20def8b1f6c2e7ec27069030dc49e6107fb643dd3cc74026905097"
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
