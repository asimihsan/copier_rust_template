import { describe, it, expect, beforeEach } from 'vitest';
import { parse, ensureInitialized } from '../test-setup';

describe('parser', () => {
    beforeEach(async () => {
        await ensureInitialized();
    });

    it('should parse simple text', () => {
        const result = parse('1+2');
        expect(result).toBe('3');
    });
});