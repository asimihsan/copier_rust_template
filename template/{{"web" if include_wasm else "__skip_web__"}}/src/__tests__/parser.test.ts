import { describe, it, expect, beforeEach } from 'vitest';
import { greet, ensureInitialized } from '../test-setup';

describe('greeting', () => {
    beforeEach(async () => {
        await ensureInitialized();
    });

    it('should greet a recipient', () => {
        const result = greet('Ihsan');
        expect(result).toBe('Hello, Ihsan! Welcome to {{ project_name }}.');
    });
});
