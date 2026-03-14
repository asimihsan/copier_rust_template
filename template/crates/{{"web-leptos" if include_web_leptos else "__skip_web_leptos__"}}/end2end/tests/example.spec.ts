/**
 * Copyright 2025 Asim Ihsan
 *
 * This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
 * If a copy of the MPL was not distributed with this file, You can obtain one at https://mozilla.org/MPL/2.0/.
 *
 * SPDX-License-Identifier: MPL-2.0
 */

import { test, expect } from "@playwright/test";

test("homepage has title 'Leptos + Tailwindcss'", async ({ page }) => {
  await page.goto("http://localhost:8080/");

  await expect(page).toHaveTitle("Leptos + Tailwindcss");
});
