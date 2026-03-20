export interface JwtPayload {
  sub: string;
  email: string;
  displayName: string;
  type: 'access' | 'refresh';
}
