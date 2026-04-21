import { Component } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';

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
export class AppComponent {
  message = '';
  inputMessage = '';
  echo = '';

  constructor(private http: HttpClient) {
    this.http.get<any>('/api/message')
      .subscribe(res => {
        this.message = res.message;
      });
  }

  sendMessage() {
    this.http.post<any>('/api/echo', { message: this.inputMessage })
      .subscribe(res => {
        this.echo = res.echo;
      });
  }
}