import { createServerClient } from "@supabase/ssr";
import { SupabaseClient } from "@supabase/supabase-js";
import { getCookies, setCookie } from "@tanstack/react-start/server";

export function createSupabaseClient(): SupabaseClient {
    return createServerClient("", "", {
        cookies: {
            getAll() {
                return Object.entries(getCookies()).map(([name, value]) => ({ name, value }));
            },
            setAll(cookies) {
                cookies.forEach((cookie) => {
                    setCookie(cookie.name, cookie.value);
                });
            },
        },
    });
}
