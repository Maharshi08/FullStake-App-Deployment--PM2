import { Component, Inject, PLATFORM_ID, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { FormsModule } from '@angular/forms';
import { CommonModule, isPlatformBrowser } from '@angular/common';
import { environment } from '../environments/environment';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule, FormsModule],
  template: `
    <h1>Full Stack App</h1>
    <p>{{ message }}</p>

    <input [(ngModel)]="inputMessage" placeholder="Enter message" />
    <button (click)="sendMessage()">Send</button>

    <p>Echo: {{ echo }}</p>
  `
})
export class AppComponent implements OnInit {
  message = '';
  inputMessage = '';
  echo = '';

  isBrowser: boolean;

  constructor(
    private http: HttpClient,
    @Inject(PLATFORM_ID) private platformId: Object
  ) {
    this.isBrowser = isPlatformBrowser(this.platformId);
  }

  ngOnInit() {
    if (this.isBrowser) {
      this.loadMessage();
    }
  }

  loadMessage() {
    this.http.get<any>(`${environment.apiUrl}/message`)
      .subscribe({
        next: (res) => this.message = res.message,
        error: (err) => {
          console.error('API Error:', err);
          this.message = 'Backend not reachable';
        }
      });
  }

  sendMessage() {
    if (!this.isBrowser) return;

    this.http.post<any>(`${environment.apiUrl}/echo`, {
      message: this.inputMessage
    }).subscribe({
      next: (res) => this.echo = res.echo,
      error: (err) => {
        console.error('Echo Error:', err);
        this.echo = 'Error sending message';
      }
    });
  }
}