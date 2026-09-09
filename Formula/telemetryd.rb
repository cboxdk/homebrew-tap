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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.49.1/telemetryd-0.49.1-aarch64-apple-darwin.tar.gz"
      sha256 "d20b3ec98d42b20848354dc7b0dbcc8c19b39bfa87d5fe80cf41edcc402a760e"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.49.1/telemetryd-0.49.1-x86_64-apple-darwin.tar.gz"
      sha256 "6d3dd1c7d1152ef632be9b7589b5bd0671a8bb12abd9a49b76292e95824de5c5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.49.1/telemetryd-0.49.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "94d2cc07f4022e1d91caa9c4daa8f73bcd83067afbd870ba6742a394c5c07865"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.49.1/telemetryd-0.49.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "ab99150344a266b3ac14efb459f1a1b1900f4f6f90196be021d067e987e26cfe"
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
