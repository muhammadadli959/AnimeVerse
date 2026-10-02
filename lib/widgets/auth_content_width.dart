double resolveAuthContentWidth(double availableWidth) {
  if (availableWidth <= 0) return 360;
  return availableWidth > 600 ? 400 : availableWidth;
}
