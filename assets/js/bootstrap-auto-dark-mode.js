document.addEventListener('DOMContentLoaded', function() {
  function toggleTheme() {
    const html = document.documentElement;
    const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
    if (prefersDark) {
      html.setAttribute('data-bs-theme', 'dark');
    } else {
      html.setAttribute('data-bs-theme', 'light');
    }
  }

  // Initial call to set the correct theme
  toggleTheme();

  // Listen for system theme changes
  window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', toggleTheme);

  // Optionally, add a toggle button to allow manual switching
  // You would need to add a button to your HTML and handle the click event
  // to toggle the theme.
});
